Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9287B7FE6
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 14:57:47 -0500 (CDT)
Date: Tue, 20 Aug 2013 14:57:47 -0500
From: Geoffrey Wehrman <gwehrman@sgi.com>
Subject: Re: [PATCH 51/50] xfs: add xfs sb v4 support for dirent filetype field
Message-ID: <20130820195747.GD2751@sgi.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<20130819201940.516942026@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130819201940.516942026@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 19, 2013 at 03:19:36PM -0500, Mark Tinguely wrote:
| Add XFS superblock v4 support for the file type field in the
| directory entry feature.
| 
| This support adds a feature bit for version 4 superblocks and
| leaves the original superblock 5 incompatibility bit.
| 
| Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Reviewed-by: Geoffrey Wehrman <gwehrman@sgi.com>


-- 
Geoffrey Wehrman  651-683-5496  gwehrman@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
