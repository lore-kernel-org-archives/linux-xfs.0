Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VMKHJL240576 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 17:20:17 -0500
Date: Wed, 31 Oct 2012 15:22:07 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [patch 1/1] xfsdump: enable gettext
Message-ID: <20121031222207.GF20337@caliban.engr.sgi.com>
References: <20121031221513.348916389@sgi.com>
	<20121031221537.911583684@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121031221537.911583684@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Phil White <pwhite@sgi.com>, xfs@oss.sgi.com

On Wed, Oct 31, 2012 at 05:15:14PM -0500, Ben Myers wrote:
> ENABLE_GETTEXT was not being defined when --enable-gettext
> was specified as a config option, neither the German or
> Polish translations were working.  Add this define to
> builddefs.in
> 
> See commit e84ec15d in xfsprogs.

Simple enough.

Reviewed-by: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
