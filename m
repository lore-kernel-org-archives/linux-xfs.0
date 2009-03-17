Return-Path: <xfs-bounces@oss.sgi.com>
Message-Id: <C2095729-F01F-4DB9-BB06-DC8EB183882E@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090317064230.GA26111@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] XFS: Pagecache usage optimization on XFS
Date: Tue, 17 Mar 2009 10:19:58 -0500
References: <6.0.0.20.2.20090304114824.06985898@172.19.0.2>
	<20090316091606.GA1720@infradead.org>
	<6.0.0.20.2.20090317102134.06e60b30@172.19.0.2>
	<20090317064230.GA26111@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-masters@oss.sgi.com, Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, xfs@oss.sgi.com


On Mar 17, 2009, at 1:42 AM, Christoph Hellwig wrote:

> On Tue, Mar 17, 2009 at 01:03:08PM +0900, Hisashi Hifumi wrote:
>>
>> At 18:16 09/03/16, Christoph Hellwig wrote:
>>> This looks like it should work.  did you run XFSQA on a small  
>>> blocksize
>>> filesystem with this applied?
>>
>> Hi.
>> I did XFSQA test on XFS partition with this patch applied.
>>
>> arch:ia64
>> pagesize:16K
>> blocksize:2K
>
> Thanks a lot.  In that case the patch is fine with me.
>
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> (as in reviewing the generic function to make sense with XFS :))

Make sense to me too.

Reviewed-by: Felix Blyakher <felixb@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
