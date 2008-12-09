Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB99HRoB011236 for <xfs@oss.sgi.com>; Tue, 9 Dec 2008 03:17:29 -0600
Date: Tue, 9 Dec 2008 04:17:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: New XFS git tree on oss.sgi.com
Message-ID: <20081209091725.GA26180@infradead.org>
References: <492BA7AD.5080007@sgi.com> <20081125081644.GA20644@infradead.org>
	<492C0B3D.3040002@thebarn.com> <492CA07F.1030803@sgi.com>
	<492CC201.3080304@xfs.org>
	<ncc3ah6lyiw.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ncc3ah6lyiw.fsf@itchy.melbourne.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Niv Sardi <xaiki@sgi.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

Now that the xfs-dev branch was updated after a while I tried a git pull
an get a useless error message:

hch@bigmac:~/work/xfs-dev$ git-pull 
You asked me to pull without telling me which branch you
want to merge with, and 'branch.origin/xfs-dev.merge' in
your configuration file does not tell me either.  Please
name which branch you want to merge on the command line and
try again (e.g. 'git pull <repository> <refspec>').
See git-pull(1) for details on the refspec.

If you often merge with the same branch, you may want to
configure the following variables in your configuration
file:

    branch.origin/xfs-dev.remote = <nickname>
    branch.origin/xfs-dev.merge = <remote-ref>
    remote.<nickname>.url = <url>
    remote.<nickname>.fetch = <refspec>

See git-config(1) for details.


Can you please make each of the current branches a proper git tree
that is easy to work with?  Alternatively I'll just completely stop
bothering with the dev tree if it's such a pain in the ass.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
