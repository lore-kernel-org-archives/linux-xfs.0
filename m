Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADKMnej142318 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 14:22:49 -0600
Message-ID: <50A2AC91.9080103@sgi.com>
Date: Tue, 13 Nov 2012 14:24:49 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfstests: resolve compiler warnings
References: <20121109132358.256359544@sgi.com>
	<20121109132714.075017013@sgi.com>
In-Reply-To: <20121109132714.075017013@sgi.com>
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
> This patch resolves the following compiler/configure warnings:
>
>   configure: WARNING: unrecognized options: --enable-lib64
>   warning: 'xxxx' may be used uninitialized in this function [-Wuninitialized]
>   warning: variable 'xxx' set but not used [-Wunused-but-set-variable]
>   warning: call to function 'foo' without a real prototype [-Wunprototyped-calls]
>
> Signed-off-by: Rich Johnston<rjohnston@sgi.com>
>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
