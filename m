Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VIQCSS228336 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 13:26:12 -0500
Date: Wed, 31 Oct 2012 13:28:00 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Build system revamp, part 1
Message-ID: <20121031182800.GA9783@sgi.com>
References: <1337930323-575-1-git-send-email-jengelh@inai.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1337930323-575-1-git-send-email-jengelh@inai.de>
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
To: Jan Engelhardt <jengelh@inai.de>
Cc: xfs@oss.sgi.com

Jan,

On Fri, May 25, 2012 at 09:18:37AM +0200, Jan Engelhardt wrote:
> 
> The following changes since commit a8decaf0cf49d3db099e8dc419390c353e2b19ad:
> 
>   3.1.8 release (2012-03-20 13:52:15 -0500)
> 
> are available in the git repository at:
>   git://inai.de/xfsprogs master
> 
> Jan Engelhardt (6):
>       build: rename to configure.ac
>       build: use new autoconf constructs
>       build: remove home-baked long/ptr size detection
>       build: use standard type intptr_t
>       build: use standard type uintptr_t
>       Update .gitignore

Patches 2, 3, and 6 have been committed to git://oss.sgi.com/xfs/cmds/xfsprogs.git, master branch.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
