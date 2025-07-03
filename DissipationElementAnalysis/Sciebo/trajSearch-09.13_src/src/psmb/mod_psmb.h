#ifndef __PSMB_H__
#define __PSMB_H__

#if (_PAGE_SIZED_MEMORY_BLOCKS_>0)

#define PAGE_SIZE 4*1024_8
#define psmb_arr_3d(array,i,j,k)   array(mod(((i)-1),8)+1, mod(((j)-1),8)+1, mod(((k)-1),8)+1, (((i)-1)/8)+1, (((j)-1)/8)+1, (((k)-1)/8)+1)
#define psmb_arr_4d(array,i,j,k,v) array(mod(((i)-1),8)+1, mod(((j)-1),8)+1, mod(((k)-1),8)+1, v, (((i)-1)/8)+1, (((j)-1)/8)+1, (((k)-1)/8)+1)

#endif

#if (_PAGE_SIZED_MEMORY_BLOCKS_==2)

#define psmb_alloc_3d(arr,d1,d2,d3,es) call posix_memalign(cptr, PAGE_SIZE, es*(d1+8)*(d2+8)*(d3+8)); call c_f_pointer(cptr, arr, (/8,8,8,(d1/8)+1,(d2/8)+1,(d3/8)+1/))
#define psmb_alloc_4d(arr,d1,d2,d3,d4,es) call posix_memalign(cptr, PAGE_SIZE, es*(d1+8)*(d2+8)*(d3+8)*d4); call c_f_pointer(cptr, arr, (/8,8,8,d4,(d1/8)+1,(d2/8)+1,(d3/8)+1/))
#define psmb_free(arr) call free(c_loc(arr)); nullify(arr)

#elif (_PAGE_SIZED_MEMORY_BLOCKS_==1)

#define psmb_alloc_3d(array,dim1,dim2,dim3,es) allocate(array(8,8,8,(dim1)/8+1,(dim2)/8+1,(dim3)/8+1))
#define psmb_alloc_4d(array,dim1,dim2,dim3,dim4,es) allocate(array(8,8,8,(dim4),(dim1)/8+1,(dim2)/8+1,(dim3)/8+1))
#define psmb_free(array) deallocate(array)

#elif (_PAGE_SIZED_MEMORY_BLOCKS_==0)

!#warning undefining PSMB
#undef _PAGE_SIZED_MEMORY_BLOCKS_

#endif

#endif
