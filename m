Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0564CZi188711 for <xfs@oss.sgi.com>; Thu, 5 Jan 2012 00:04:12 -0600
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id K09wS9mbsUdtkPxy for
	<xfs@oss.sgi.com>; Wed, 04 Jan 2012 22:04:10 -0800 (PST)
Message-ID: <4F053D51.7010107@oracle.com>
Date: Thu, 05 Jan 2012 14:04:01 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Another SEEK_DATA/SEEK_HOLE  tester
References: <4EFB1FEC.1050800@oracle.com>
	<20120104164356.GA12924@infradead.org>
In-Reply-To: <20120104164356.GA12924@infradead.org>
Reply-To: jeff.liu@oracle.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

On 01/05/2012 12:43 AM, Christoph Hellwig wrote:

> On Wed, Dec 28, 2011 at 09:55:56PM +0800, Jeff Liu wrote:
>> A test tool to verify larger files with more extents(it can be used, but still need improvements).
> 
> Can you turn it into something that gets run automatically?

I have reposted this tester at:
http://patchwork.xfs.org/patch/3109/

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
