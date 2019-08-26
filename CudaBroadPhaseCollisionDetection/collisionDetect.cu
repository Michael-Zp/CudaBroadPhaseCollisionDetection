
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

#include "DataTypes.h"
#include "Constants.h"
#include "Helpers.h"


__global__ void VecAdd()
{

}



int main()
{
	cudaError_t err = cudaSuccess;

	Circle *circles = (Circle*)malloc(sizeof(Circle) * OBJECT_COUNT);
	

	circles[0].center.x = 0;
	circles[0].center.y = 0;
	circles[0].radius = CELLSIZE / 4;

	circles[1].center.x = 0;
	circles[1].center.y = 1;
	circles[1].radius = CELLSIZE / 4;

	circles[2].center.x = 1;
	circles[2].center.y = 0;
	circles[2].radius = CELLSIZE / 4;

	circles[3].center.x = 1;
	circles[3].center.y = 1;
	circles[3].radius = CELLSIZE / 4;



	CellIdItem *cellIds = (CellIdItem*)malloc(sizeof(CellIdItem) * MAX_ITEMS);
	ControlBitsItem *controlBits = (ControlBitsItem*)malloc(sizeof(ControlBitsItem) * MAX_ITEMS);
	


	for (int i = 0; i < OBJECT_COUNT; i++)
	{
		cellIds[i].Cells[0] = posToHash(circles[i].center);
		controlBits[i].HCellType = posToCellType(circles[i].center);
		
		glm::uvec2 coords = posToCoords(circles[i].center);

		int collisionCount = 0;

		for (int x = -1; x <= 1; x++)
		{
			for (int y = -1; y <= 1; y++)
			{
				if (x == 0 && y == 0)
				{
					continue;
				}

				GLuint currentX = coords.x + x;
				GLuint currentY = coords.y + y;

				if (collides(circles[i], coordsToGridBox(currentX, currentY)))
				{
					cellIds[i].Cells[collisionCount + 1] = posToHash(circles[i].center + glm::vec2(x * CELLSIZE, y * CELLSIZE));
					collisionCount++;
				}
			}
		}

		for (int u = collisionCount + 1; u < MAX_OBJECT_INTERSECTIONS; u++)
		{
			cellIds[i].Cells[u] = 0xffffffff;
		}
	}

	for (int i = 0; i < OBJECT_COUNT; i++)
	{
		printf("cellIds[%d] HomeCell = %d\n", i, cellIds[i].Cells[0]);
		printf("cellIds[%d] HomeCellType = %d\n", i, controlBits[i].HCellType);
		for (int u = 0; u < MAX_OBJECT_INTERSECTIONS; u++)
		{
			printf("cellIds[%d] Cells [%d] = %d\n", i, u, cellIds[i].Cells[u]);
		}
		printf("----\n");
	}

    return err;
}