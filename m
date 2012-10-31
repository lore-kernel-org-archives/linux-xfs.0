Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VH19o2220711 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 12:01:09 -0500
Date: Wed, 31 Oct 2012 12:03:00 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 0/2] xfsdump: build system revamp
Message-ID: <20121031170300.GH405@sgi.com>
References: <20121030213150.696351829@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121030213150.696351829@sgi.com>
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
To: xfs@oss.sgi.com
Cc: Jan Engelhardt <jengelh@inai.de>, Rich Johnston <rjohnston@sgi.com>

On Tue, Oct 30, 2012 at 04:31:50PM -0500, Ben Myers wrote:
> Here are Jan Engelhardt's patches originally posted here
> http://oss.sgi.com/archives/xfs/2012-05/msg00323.html
> as they apply to xfsdump.
> 
> Patch 2 applied without much modification, patch 3 was not necessary for
> xfsdump, and patch 6 did not apply at all so I implemented that.

These two have been committed to git://oss.sgi.com/xfs/cmds/xfsdump.git, master branch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
