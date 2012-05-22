Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4M1QI8X065395 for <xfs@oss.sgi.com>; Mon, 21 May 2012 20:26:18 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id ki73KW6Id4xziUXg for <xfs@oss.sgi.com>;
	Mon, 21 May 2012 18:26:17 -0700 (PDT)
Message-ID: <4FBAEB38.2040105@sandeen.net>
Date: Mon, 21 May 2012 20:26:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] xfs_repair fixes for fragmented multiblock v2 dirs
References: <4FBABCAB.20300@redhat.com>
In-Reply-To: <4FBABCAB.20300@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 5/21/12 5:07 PM, Eric Sandeen wrote:
> 3 fixes for xfs_repair on fragmented multiblock v2 dirs.
> 
> xfs_repair: Fix fragmented multiblock dir2 handling in blkmap_getn()
> xfs_repair: Document & robustify blkmap_next_off()
> xfs_repair: handle fragmented multiblock dir2 in process_leaf_node_dir2()
> 
> xfs_check seems to handle things just fine, interstingly enough.
> 
> -Eric

Grr.

Well, I did send the other two.

but it seems to be eaten/stuck/constipated.  Again.

Grr.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
