Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13H23MI145398 for <xfs@oss.sgi.com>; Fri, 3 Feb 2012 11:02:03 -0600
Date: Fri, 3 Feb 2012 11:02:05 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC PATCH 3/4] Change xfs_sb_from_disk() interface to take a
	mount pointer
Message-ID: <20120203170205.GJ13095@sgi.com>
References: <20120123173118.31546.3353.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173137.31546.33777.sendpatchset@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120123173137.31546.33777.sendpatchset@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 23, 2012 at 11:31:37AM -0600, Chandra Seetharaman wrote:
> Change xfs_sb_from_disk() interface to take a mount pointer
> instead of a superblock pointer.
> 
> This is to print mount point specific error messages in future
> fixes.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looking good!
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
