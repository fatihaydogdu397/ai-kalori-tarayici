import os
import re

def process_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Rule 1: Section headers (16 w800 -> 15.sp w700)
    content = re.sub(r'fontSize:\s*16(?:\.sp)?,\s*fontWeight:\s*FontWeight\.w800', r'fontSize: 15.sp, fontWeight: FontWeight.w700', content)
    
    # Rule 2: Card Titles (14 w800 -> 14.sp w700)
    content = re.sub(r'fontSize:\s*14(?:\.sp)?,\s*fontWeight:\s*FontWeight\.w800', r'fontSize: 14.sp, fontWeight: FontWeight.w700', content)
    content = re.sub(r'fontSize:\s*14(?:\.sp)?,\s*fontWeight:\s*FontWeight\.w600', r'fontSize: 14.sp, fontWeight: FontWeight.w700', content)
    
    # Rule 3: Body Text (14 or 13 with w500/w600/no-weight)
    # Too dangerous to wholesale replace, but we can do:
    # fontSize: 13, fontWeight: FontWeight.w600 -> fontSize: 13.sp, fontWeight: FontWeight.w500
    content = re.sub(r'fontSize:\s*13(?:\.sp)?,\s*fontWeight:\s*FontWeight\.w600', r'fontSize: 13.sp, fontWeight: FontWeight.w500', content)
    content = re.sub(r'fontSize:\s*13(?:\.sp)?,\s*fontWeight:\s*FontWeight\.w700', r'fontSize: 13.sp, fontWeight: FontWeight.w500', content)
    
    # Rule 4: Auxiliary (10/11/12 muted -> 12.sp w400)
    content = re.sub(r'fontSize:\s*11(?:\.sp)?,\s*color:\s*(textMuted|isDark \? AppColors\.darkTextSecondary : AppColors\.lightTextSecondary)', r'fontSize: 12.sp, fontWeight: FontWeight.w400, color: \1', content)
    content = re.sub(r'fontSize:\s*10(?:\.sp)?,\s*color:\s*(textMuted|isDark \? AppColors\.darkTextSecondary : AppColors\.lightTextSecondary)', r'fontSize: 12.sp, fontWeight: FontWeight.w400, color: \1', content)
    content = re.sub(r'fontSize:\s*12(?:\.sp)?,\s*color:\s*(textMuted|isDark \? AppColors\.darkTextSecondary : AppColors\.lightTextSecondary)', r'fontSize: 12.sp, fontWeight: FontWeight.w400, color: \1', content)
    
    # Make sure we don't end up with duplicate fontWeights if it already had one
    content = re.sub(r'fontWeight:\s*FontWeight\.w[4-9]00,\s*fontWeight:\s*FontWeight\.w[4-9]00', r'fontWeight: FontWeight.w400', content)

    # Some hardcoded sp fixes
    content = re.sub(r'fontSize:\s*15(?!\.sp)', r'fontSize: 15.sp', content)
    content = re.sub(r'fontSize:\s*14(?!\.sp)', r'fontSize: 14.sp', content)
    content = re.sub(r'fontSize:\s*13(?!\.sp)', r'fontSize: 13.sp', content)
    content = re.sub(r'fontSize:\s*12(?!\.sp)', r'fontSize: 12.sp', content)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

if __name__ == '__main__':
    targets = [
        'lib/screens/profile_screen.dart',
        'lib/screens/settings_screen.dart',
        'lib/screens/progress_screen.dart',
        'lib/screens/history_screen.dart'
    ]
    for target in targets:
        full_path = os.path.join(os.getcwd(), target)
        if os.path.exists(full_path):
            process_file(full_path)
            print(f'Processed {target}')
