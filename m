Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9KFWj08009675 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 10:32:45 -0500
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5319513C138F
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:40:50 -0700 (PDT)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id bsTXdxwIVHEPwAM5 for
	<xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:40:50 -0700 (PDT)
Message-ID: <4EA03F08.4050400@oracle.com>
Date: Thu, 20 Oct 2011 23:32:24 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] 265: Functional test case for the btrfs
	de-fragmentation
References: <20111013005652.GM3159@dastard>
	<1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
	<1318919336-32206-3-git-send-email-Anand.Jain@oracle.com>
	<20111019094356.GC3083@infradead.org>
In-Reply-To: <20111019094356.GC3083@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com



On 19/10/2011 17:43, Christoph Hellwig wrote:
> On Tue, Oct 18, 2011 at 02:28:55PM +0800, Anand Jain wrote:
>> To verify the btrfs de-fragmentation does not fail.
> 
> Any reason you can't simply fold btrfs defragmentation testing into
> the existing common defragmentation test (218)?

  oh! 218 ! let me defer defrag for now. will get the other test-cases
  going. thanks
anand

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
