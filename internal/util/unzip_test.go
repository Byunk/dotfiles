package util

import (
	"archive/tar"
	"compress/gzip"
	"os"
	"path"
	"testing"

	"github.com/stretchr/testify/require"
	"github.com/ulikunitz/xz"
)

func TestNewUnZipper(t *testing.T) {
	name := "test"
	src := "/path/to/source/file.tar"
	dst := "/path/to/destination"

	uz := NewUnZipper(name, src, dst)

	require.Equal(t, name, uz.name)
	require.Equal(t, src, uz.src)
	require.Equal(t, dst, uz.dst)
	require.NotNil(t, uz.files)
	require.Empty(t, uz.files)
}

func TestUnZipper_UnzipUnsupportedExtension(t *testing.T) {
	uz := NewUnZipper("test", "/path/to/source/file.zip", "/path/to/destination")

	_, err := uz.Unzip()
	require.Error(t, err)
}

func TestUnZipper_UnzipTar(t *testing.T) {
	// Prepare a tar archive
	tmpDir := t.TempDir()
	src := path.Join(tmpDir, "test.tar")
	dst := path.Join(tmpDir, "output")

	// Create a tar file for testing
	createTestTarFile(t, src)

	uz := NewUnZipper("test", src, dst)
	_, err := uz.Unzip()
	require.NoError(t, err)

	// Check if the files are extracted
	_, err = os.Stat(path.Join(dst, "testfile.txt"))
	require.NoError(t, err)
}

func TestUnZipper_UnzipGz(t *testing.T) {
	// Prepare a gz archive
	tmpDir := t.TempDir()
	src := path.Join(tmpDir, "test.tar.gz")
	dst := path.Join(tmpDir, "output")

	// Create a gz file for testing
	createTestGzFile(t, src)

	uz := NewUnZipper("test", src, dst)
	_, err := uz.Unzip()
	require.NoError(t, err)

	// Check if the files are extracted
	_, err = os.Stat(path.Join(dst, "testfile.txt"))
	require.NoError(t, err)
}

func TestUnZipper_UnzipXz(t *testing.T) {
	// Prepare an xz archive
	tmpDir := t.TempDir()
	src := path.Join(tmpDir, "test.tar.xz")
	dst := path.Join(tmpDir, "output")

	// Create an xz file for testing
	createTestXzFile(t, src)

	uz := NewUnZipper("test", src, dst)
	_, err := uz.Unzip()
	require.NoError(t, err)

	// Check if the files are extracted
	_, err = os.Stat(path.Join(dst, "testfile.txt"))
	require.NoError(t, err)
}

// Helper functions to create test archives
func createTestTarFile(t *testing.T, filePath string) {
	file, err := os.Create(filePath)
	require.NoError(t, err)
	defer file.Close()

	tw := tar.NewWriter(file)
	defer tw.Close()

	hdr := &tar.Header{
		Name: "testfile.txt",
		Mode: 0600,
		Size: int64(len("hello world")),
	}
	err = tw.WriteHeader(hdr)
	require.NoError(t, err)

	_, err = tw.Write([]byte("hello world"))
	require.NoError(t, err)
}

func createTestGzFile(t *testing.T, filePath string) {
	file, err := os.Create(filePath)
	require.NoError(t, err)
	defer file.Close()

	gw := gzip.NewWriter(file)
	defer gw.Close()

	tw := tar.NewWriter(gw)
	defer tw.Close()

	hdr := &tar.Header{
		Name: "testfile.txt",
		Mode: 0600,
		Size: int64(len("hello world")),
	}
	err = tw.WriteHeader(hdr)
	require.NoError(t, err)

	_, err = tw.Write([]byte("hello world"))
	require.NoError(t, err)
}

func createTestXzFile(t *testing.T, filePath string) {
	file, err := os.Create(filePath)
	require.NoError(t, err)
	defer file.Close()

	xw, err := xz.NewWriter(file)
	require.NoError(t, err)
	defer xw.Close()

	tw := tar.NewWriter(xw)
	defer tw.Close()

	hdr := &tar.Header{
		Name: "testfile.txt",
		Mode: 0600,
		Size: int64(len("hello world")),
	}
	err = tw.WriteHeader(hdr)
	require.NoError(t, err)

	_, err = tw.Write([]byte("hello world"))
	require.NoError(t, err)
}
