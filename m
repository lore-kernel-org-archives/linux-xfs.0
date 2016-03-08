Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 97F137CA0
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 20:35:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B037AC002
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 18:35:30 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id pJlQDLnVo0TCMtI2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Mar 2016 18:35:28 -0800 (PST)
Date: Mon, 7 Mar 2016 18:34:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] xfsdocs: update the on-disk format with changes for
	Linux 4.5
Message-ID: <20160308023458.GC27689@birch.djwong.org>
References: <20160305003505.28327.95288.stgit@birch.djwong.org>
	<20160305003518.28327.15601.stgit@birch.djwong.org>
	<20160305203656.GB4989@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160305203656.GB4989@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Mar 05, 2016 at 12:36:56PM -0800, Christoph Hellwig wrote:
> > -The inode's core is 96 bytes in size and contains information about the file
> > +The inode's core is 176 bytes in size and contains information about the file
> 
> maybe this should read  "96 or 176 bytes in size"
> 

Ok, I'll reword it to state that it's 96 on V4 and 176 on V5.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
