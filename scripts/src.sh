cat << EOF > $SRC/global.css
@tailwind base;

@tailwind components;

@tailwind utilities;

/* @font-face {
  font-family: 'YOUR FONT';
  font-style: normal;
  font-weight: 400; // normal
  font-display: swap;
  src: url('./fonts/your-font-regular.ttf') format('truetype');
} */

/* @font-face {
  font-family: 'YOUR FONT';
  font-style: normal;
  font-weight: 600; // semibold
  font-display: swap;
  src: url('./fonts/your-font-semibold.ttf') format('truetype');
} */
EOF

cat << EOF > $SRC/global.d.ts
declare module '*.css' {
  const classNames: Record<string, string>;
  export default classNames;
}

declare module '*.mp4' {
  const sourcePath: string;
  export default sourcePath;
}

declare module '*.svg' {
  const sourcePath: string;
  export default sourcePath;
}

declare module '*.pdf' {
  const sourcePath: string;
  export default sourcePath;
}
EOF

cat << EOF > $SRC/index.html
<!DOCTYPE html>
<html lang="ru">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Application name</title>
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>
EOF

cat << EOF > $SRC/index.tsx
import './global.css';

import React, {FC} from 'react';
import {render} from 'react-dom';

import {MainPage} from './pages/MainPage';

export const App: FC = () => (
  <>
    <MainPage />
  </>
);

const root = document.getElementById('root');

render(<App />, root);
EOF

cat << EOF > $TEMPLATES/PageTemplate.tsx
import React, {FC} from 'react';

import {PageTitle} from '../components/PageTitle'

type TPageTemplate = FC<{
  title: string
}>

export const PageTemplate: TPageTemplate = ({ title, children }) => (
  <div>
    <PageTitle>{title}</PageTitle>
    <div>{children}</div>
  </div>
)
EOF

cat << EOF > $PAGES/MainPage.tsx
import React, {FC} from 'react';

import termsOrUseSrc from '../docs/terms-of-use.pdf';

import {PageTemplate} from '../templates/PageTemplate';

export const MainPage: FC = () => (
  <PageTemplate title='Main page'>
    <ul>
      <li>
        <a href={termsOrUseSrc}>Terms of use</a>
      </li>
    </ul>
  </PageTemplate>
);
EOF

cat << EOF > $COMPONENTS/PageTitle.tsx
import React, {FC} from 'react';

export const PageTitle: FC = ({children}) => <h1>{children}</h1>
EOF

cat << EOF > $DOCS/terms-of-use.pdf
- Terms of use -
EOF