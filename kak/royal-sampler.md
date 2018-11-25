# royal sampler

a sample document for my text editor


## go
```go
// play plays until it stops
func play() (stop func()) {
	// the tempo is 120 bpm
	tunes := map[string]time.Duration{
		"♩  ": time.Second / 2, "♩. ": 3 * time.Second / 4,
		"♪  ": time.Second / 4, "♪. ": 3 * time.Second / 8,
		"♫  ": time.Second / 2, "♬  ": time.Second / 4,
	}

	x := make(chan struct{})
	go func() {
		for {
			for n, d := range tunes {
				fmt.Fprint(os.Stderr, n)
				select {
				case <-time.After(d):
				case <-x:
					return
				}
				break
			}
		}
	}()

	return func() { x <- struct{}{}; close(x) }
}
```

## sh
```sh
#!/bin/bash

die() { echo "oh noes: $*" >&2; exit 1; }

for go in go go go; do
        hash "$go" &>/dev/null || die "missing $go"
done

GO111MODULE=on GOOS=linux CGO_ENABLED=0 GOARCH=amd64 go build || die "build"
```

## yaml
```yaml
test:
  fields:
    when: 2000-01-01
    yeah: false
    int: 0
    float: 1.0
    string: "aaa"
    alsoString: |
      something something words
      ¯\_(ツ)_/¯
    things:
      - thing: blep
      - thing: mlem
```
