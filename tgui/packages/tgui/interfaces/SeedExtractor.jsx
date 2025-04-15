import { sortBy, map } from 'common/collections';
import { flow } from 'tgui-core/fp';
import { toTitleCase } from 'tgui-core/string';
import { useBackend } from '../backend';
import { Button, Section, Table } from 'tgui-core/components';
import { Window } from '../layouts';

/**
 * This method takes a seed string and splits the values
 * into an object
 */
const splitSeedString = (text) => {
  const re = /([^;=]+)=([^;]+)/g;
  const ret = {};
  let m;
  do {
    m = re.exec(text);
    if (m) {
      ret[m[1]] = m[2] + '';
    }
  } while (m);
  return ret;
};

export const SeedExtractor = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={1000} height={400} resizable>
      <Window.Content scrollable>
        <Section title="Stored seeds:">
          <Table cellpadding="3" textAlign="center">
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Lifespan</Table.Cell>
              <Table.Cell>Endurance</Table.Cell>
              <Table.Cell>Maturation</Table.Cell>
              <Table.Cell>Production</Table.Cell>
              <Table.Cell>Yield</Table.Cell>
              <Table.Cell>Potency</Table.Cell>
              <Table.Cell>Instability</Table.Cell>
              <Table.Cell>Stock</Table.Cell>
            </Table.Row>
            {map(data.seeds, (seed) => (
			    <Table.Row key={seed.key}>
                <Table.Cell bold>{seed.name}</Table.Cell>
                <Table.Cell>{seed.lifespan}</Table.Cell>
                <Table.Cell>{seed.endurance}</Table.Cell>
                <Table.Cell>{seed.maturation}</Table.Cell>
                <Table.Cell>{seed.production}</Table.Cell>
                <Table.Cell>{seed.yield}</Table.Cell>
                <Table.Cell>{seed.potency}</Table.Cell>
                <Table.Cell>{seed.instability}</Table.Cell>
                <Table.Cell>
                  <Button
                    content="Vend"
                    onClick={() =>
                      act('select', {
                        item: seed.key,
                      })
                    }
                  />
                  ({seed.amount} left)
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
