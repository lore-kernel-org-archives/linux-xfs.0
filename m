Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9ITaNh136622 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 12:29:36 -0600
Message-ID: <509D4C05.2030007@sgi.com>
Date: Fri, 9 Nov 2012 12:31:33 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfsdump: extend fs_info to gather fs feature flags
References: <50788C50.40600@redhat.com> <50788D06.2030309@sandeen.net>
In-Reply-To: <50788D06.2030309@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 10/12/2012 04:35 PM, Eric Sandeen wrote:
> extend fs_info and fs_getid to return fs flags (features)
> from GEOM call as well.  Not used yet in this patch.
> Will be used in subsequent patch to detect 32-bit project
> ID filesystems.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>

Looks good Eric.
Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
