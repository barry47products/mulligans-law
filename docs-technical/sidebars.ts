import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */
const sidebars: SidebarsConfig = {
  tutorialSidebar: [
    'intro',
    {
      type: 'category',
      label: 'Getting Started',
      items: [
        'getting-started/installation',
        // Uncomment as you create these pages:
        // 'getting-started/local-development',
        // 'getting-started/first-contribution',
        // 'getting-started/troubleshooting',
      ],
    },
    {
      type: 'category',
      label: 'Architecture',
      items: [
        'architecture/overview',
        // Uncomment as you create these pages:
        // 'architecture/clean-architecture',
        // 'architecture/offline-first',
        // 'architecture/database-design',
      ],
    },
    {
      type: 'category',
      label: 'Development',
      items: [
        'workflow/development',
      ],
    },
    {
      type: 'category',
      label: 'Testing',
      items: [
        'testing/strategy',
        // Uncomment as you create these pages:
        // 'testing/unit-testing',
        // 'testing/widget-testing',
        // 'testing/integration-testing',
      ],
    },
    // Uncomment these categories as you add pages:
    // {
    //   type: 'category',
    //   label: 'Features',
    //   items: [
    //     'features/authentication',
    //     'features/score-capture',
    //     'features/leaderboards',
    //     'features/tournaments',
    //   ],
    // },
    // {
    //   type: 'category',
    //   label: 'API Reference',
    //   items: [
    //     'api/repositories',
    //     'api/use-cases',
    //     'api/blocs',
    //   ],
    // },
  ],
};

export default sidebars;
