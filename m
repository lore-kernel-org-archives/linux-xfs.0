Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9PJkXUV146214 for <xfs@oss.sgi.com>; Thu, 25 Oct 2012 14:46:33 -0500
Message-ID: <5089977F.6050907@sgi.com>
Date: Thu, 25 Oct 2012 14:48:15 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 1/4] [PATCH] dmapi: rename configure.in to configure.ac
References: <20121025183634.486901001@sgi.com>
	<20121025183726.677374542@sgi.com>
In-Reply-To: <20121025183726.677374542@sgi.com>
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
To: bpm@sgi.com
Cc: Mike Frysinger <vapier@gentoo.org>, xfs@oss.sgi.com

On 10/25/12 13:36, bpm@sgi.com wrote:
> configure.in has been renamed to configure.ac.  Update the Makefile.
>
> Signed-off-by: Ben Myers<bpm@sgi.com>
> ---
>   Makefile |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

Add a:

  git mv configure.in configure.ac

Then:

Reviewed-by Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
