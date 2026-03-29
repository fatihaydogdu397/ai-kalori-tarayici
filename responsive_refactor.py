import os
import re

def process_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Skip files that shouldn't be touched or already have ScreenUtil imported
    if "flutter_screenutil" in content:
        return

    # Add import
    import_stmt = "import 'package:flutter_screenutil/flutter_screenutil.dart';\n"
    
    # Simple regex replacing rules
    # fontSize: 14 -> fontSize: 14.sp
    content = re.sub(r'fontSize:\s*(\d+)(?!\.sp|\.w|\.h|\.r)', r'fontSize: \1.sp', content)
    content = re.sub(r'fontSize:\s*(\d+\.\d+)(?!\.sp|\.w|\.h|\.r)', r'fontSize: \1.sp', content)
    
    # SizedBox(height: 20) -> SizedBox(height: 20.h)
    content = re.sub(r'SizedBox\(\s*height:\s*(\d+)(?!\.sp|\.w|\.h|\.r)\s*\)', r'SizedBox(height: \1.h)', content)
    content = re.sub(r'SizedBox\(\s*width:\s*(\d+)(?!\.sp|\.w|\.h|\.r)\s*\)', r'SizedBox(width: \1.w)', content)

    # Padding and Radii
    content = re.sub(r'Radius\.circular\(\s*(\d+)(?!\.sp|\.w|\.h|\.r)\s*\)', r'Radius.circular(\1.r)', content)
    content = re.sub(r'BorderRadius\.circular\(\s*(\d+)(?!\.sp|\.w|\.h|\.r)\s*\)', r'BorderRadius.circular(\1.r)', content)
    
    # Remove const if it was near our targets
    # This is rough but functional for Flutter
    content = re.sub(r'const\s+(SizedBox|EdgeInsets|BorderRadius)', r'\1', content)
    content = re.sub(r'const\s+(TextStyle)', r'\1', content)

    # Insert import after the last import
    imports = list(re.finditer(r"^import\s+['\"].*?['\"];$", content, re.MULTILINE))
    if imports:
        last_import = imports[-1]
        pos = last_import.end()
        content = content[:pos] + "\n" + import_stmt + content[pos:]

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

def main():
    paths = ['lib/screens', 'lib/widgets']
    for root_path in paths:
        for root, dirs, files in os.walk(root_path):
            for file in files:
                if file.endswith('.dart'):
                    process_file(os.path.join(root, file))

if __name__ == '__main__':
    main()
