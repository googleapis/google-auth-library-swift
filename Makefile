
all:	
	swift build -c release

project:
	swift package generate-xcodeproj

clean:
	rm -rf .build Package.pins


