Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BBMLna257277 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 06:22:21 -0500
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C7B1F16BBF7A
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 04:29:35 -0700 (PDT)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id 2Yi1sQg5VtokYvjv for
	<xfs@oss.sgi.com>; Tue, 11 Oct 2011 04:29:35 -0700 (PDT)
Message-ID: <4E9427A1.7020608@oracle.com>
Date: Tue, 11 Oct 2011 19:25:21 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Changes to received review comments
References: <4E3BA2F7.4080500@oracle.com> <4E44351D.4020202@oracle.com>
	<20110902084941.GB29054@infradead.org>
	<4E92C1D7.2010301@oracle.com>
	<20111010112151.GA28627@infradead.org>
In-Reply-To: <20111010112151.GA28627@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com


Christoph,

  Email following this will have patches, kindly find them.

Thanks, Anand


On 10/10/2011 07:21 PM, Christoph Hellwig wrote:
> On Mon, Oct 10, 2011 at 05:58:47PM +0800, Anand Jain wrote:
>>   Now SCRATCH_DEV is derived from SCRATCH_DEV_POOL.
>>   Moved code to delete and scan block device to common.rc and
>>   updated README.
>
> Can you resend the whole patch?   Note that xfstests is up to test 262
> in the meantime, so it will also need to be renumbered.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
