import { MantineProvider } from '@mantine/core';

export default function App() {
  return (
    <MantineProvider>
      <div className='w-full h-full grid place-items-center'>
        <h1>Hello world</h1>
      </div>
    </MantineProvider>
  );
}
