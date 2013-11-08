Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EAF687FBF
	for <xfs@oss.sgi.com>; Fri,  8 Nov 2013 05:04:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CAC908F8074
	for <xfs@oss.sgi.com>; Fri,  8 Nov 2013 03:04:16 -0800 (PST)
Message-ID: <527CC50D.4060905@redhat.com>
Date: Fri, 08 Nov 2013 06:03:41 -0500
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: XFS leadership and a new co-maintainer candidate
References: <20131107220208.GY1935@sgi.com> <527C0F64.3010906@sgi.com>
	<527C4B27.6020205@redhat.com>
In-Reply-To: <527C4B27.6020205@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ric Wheeler <rwheeler@redhat.com>, Mark Tinguely <tinguely@sgi.com>, Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, elder@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

In the XFS community, we have 2 clear leaders in terms of contributions of 
significant feaures and depth of knowledge - Christoph and Dave.

If you look at the number of patches submitted by developers since 3.0 who have 
more than 10 patches, we get the following:

     319 Author: Dave Chinner <dchinner@redhat.com>
     163 Author: Christoph Hellwig <hch@infradead.org>
      51 Author: Christoph Hellwig <hch@lst.de>
      35 Author: Linus Torvalds <torvalds@linux-foundation.org>
      34 Author: Chandra Seetharaman <sekharan@us.ibm.com>
      29 Author: Al Viro <viro@zeniv.linux.org.uk>
      28 Author: Brian Foster <bfoster@redhat.com>
      25 Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
      24 Author: Jeff Liu <jeff.liu@oracle.com>
      21 Author: Jie Liu <jeff.liu@oracle.com>
      20 Author: Mark Tinguely <tinguely@sgi.com>
      16 Author: Dave Chinner <david@fromorbit.com>
      12 Author: Eric Sandeen <sandeen@redhat.com>
      12 Author: Carlos Maiolino <cmaiolino@redhat.com>

If we as a community had more capacity for patch review, Dave's numbers would 
have jumped up even higher :)

It is certainly very welcome to bring new developers into our community, but if 
we are going to add a co-maintainer for XFS, we really need to have one of our 
two leading developers in that role.

Best regards,

Ric



On 11/07/2013 09:23 PM, Ric Wheeler wrote:
> Hi Ben,
>
> How exactly did we decide to add a new co-maintainer? Shouldn't we have some 
> discussion on the list and see some substantial history of contributions?
>
> Best regards,
>
> Ric
>
>
> On 11/07/2013 05:08 PM, Mark Tinguely wrote:
>> Updated maintainer info.
>>
>> Signed-off-by: Ben Myers <bpm@sgi.com>
>> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
>> ---
>>  MAINTAINERS |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: b/MAINTAINERS
>> ===================================================================
>> --- a/MAINTAINERS    2013-11-07 15:42:04.554561805 -0600
>> +++ b/MAINTAINERS    2013-11-07 15:42:59.034889770 -0600
>> @@ -9388,7 +9388,7 @@ F:    drivers/xen/*swiotlb*
>>  XFS FILESYSTEM
>>  P:    Silicon Graphics Inc
>>  M:    Ben Myers <bpm@sgi.com>
>> -M:    Alex Elder <elder@kernel.org>
>> +M:    Mark Tinguely <tinguely@sgi.com>
>>  M:    xfs@oss.sgi.com
>>  L:    xfs@oss.sgi.com
>>  W:    http://oss.sgi.com/projects/xfs
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
