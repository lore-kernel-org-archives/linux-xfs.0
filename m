Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADKMGNj142006 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 14:22:16 -0600
Message-ID: <50A2AC73.7060307@sgi.com>
Date: Tue, 13 Nov 2012 14:24:19 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfstests: remove unused conditional NO_XFS
References: <20121109132358.256359544@sgi.com>
	<20121109132714.002714897@sgi.com>
In-Reply-To: <20121109132714.002714897@sgi.com>
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
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

On 11/09/12 07:24, rjohnston@sgi.com wrote:
> This patch removes the unused conditional NO_XFS which was added with
> commit 332ee29d1ab7a8690ca8f6d06b0d116e3a4a4f0f:
>    "xfstests updates - rework build to be like other xfs packages ..."
>
> Signed-off-by: Rich Johnston<rjohnston@sgi.com>
>
> ---
>   ltp/doio.c      |   70 --------------------------------------------------------
>   ltp/growfiles.c |   20 ----------------
>   ltp/iogen.c     |   30 ------------------------
>   3 files changed, 120 deletions(-)

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
