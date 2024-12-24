package util

import (
	"archive/tar"
	"compress/gzip"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"

	"github.com/ulikunitz/xz"
)

type UnZipper struct {
	// package name to hint for finding the binary
	name string
	// source file to unzip
	src string
	// destination
	dst string

	files []string
}

func NewUnZipper(name, src, dst string) *UnZipper {
	return &UnZipper{
		name: name,
		src:  src,
		dst:  dst,

		files: make([]string, 0),
	}
}

func (uz *UnZipper) Unzip() (string, error) {
	r, err := os.Open(uz.src)
	if err != nil {
		return "", err
	}
	defer r.Close()

	switch filepath.Ext(uz.src) {
	case ".tar":
		if err = uz.uncompress(r); err != nil {
			return "", err
		}
	case ".gz", ".tgz":
		if err = uz.ungz(r); err != nil {
			return "", err
		}
	case ".xz":
		if err = uz.unxz(r); err != nil {
			return "", err
		}
	default:
		return "", fmt.Errorf("unsupported file extension: %s", filepath.Ext(uz.src))
	}

	return uz.findBinary()
}

func (uz *UnZipper) uncompress(r io.Reader) error {
	tarReader := tar.NewReader(r)

	// Iterate through the files in the tar archive
	for {
		header, err := tarReader.Next()
		if err == io.EOF {
			break // End of tar archive
		}
		if err != nil {
			return fmt.Errorf("failed to read tar entry: %w", err)
		}

		// Construct the full path for the extracted file
		targetPath := filepath.Join(uz.dst, header.Name)

		switch header.Typeflag {
		case tar.TypeDir:
			// Create directory
			if err := os.MkdirAll(targetPath, os.FileMode(header.Mode)); err != nil {
				return fmt.Errorf("failed to create directory: %w", err)
			}
		case tar.TypeReg:
			// Ensure the directory for the file exists
			dir := filepath.Dir(targetPath)
			if err := os.MkdirAll(dir, 0755); err != nil {
				return fmt.Errorf("failed to create file directory: %w", err)
			}

			// Create a file and write its content
			outFile, err := os.Create(targetPath)
			if err != nil {
				return fmt.Errorf("failed to create file: %w", err)
			}

			if _, err := io.Copy(outFile, tarReader); err != nil {
				outFile.Close()
				return fmt.Errorf("failed to copy file content: %w", err)
			}

			outFile.Close()

			uz.files = append(uz.files, targetPath)
		default:
			log.Printf("unsupported type: %v in %s", header.Typeflag, header.Name)
		}
	}

	return nil
}

func (uz *UnZipper) ungz(r io.Reader) error {
	gzr, err := gzip.NewReader(r)
	if err != nil {
		return err
	}
	defer gzr.Close()

	return uz.uncompress(gzr)
}

func (uz *UnZipper) unxz(r io.Reader) error {
	xzr, err := xz.NewReader(r)
	if err != nil {
		return err
	}

	return uz.uncompress(xzr)
}

// findBinary is a heuristic to find the binary in the extracted files
func (uz *UnZipper) findBinary() (string, error) {
	// if there is only one file, return it
	if len(uz.files) == 1 {
		return uz.files[0], nil
	}

	// if there is a file with the exactly the same name as the package, return it
	for _, file := range uz.files {
		if filepath.Base(file) == uz.name {
			return file, nil
		}
	}

	return "", fmt.Errorf("failed to find binary")
}
