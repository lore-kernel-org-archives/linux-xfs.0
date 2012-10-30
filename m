Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UKET7u070042 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 15:14:29 -0500
Message-ID: <509035F8.8060903@sgi.com>
Date: Tue, 30 Oct 2012 15:18:00 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] Provide dumpe2fs via standard common.config interface
References: <1350549946-17192-1-git-send-email-tracek@redhat.com>
	<1350549946-17192-2-git-send-email-tracek@redhat.com>
In-Reply-To: <1350549946-17192-2-git-send-email-tracek@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On 10/18/2012 03:45 AM, Tomas Racek wrote:
> dumpe2fs can be now accessed via $DUMPE2FS, tests that require it can
> check for its availability by _require_dumpe2fs function.
>
> Signed-off-by: Tomas Racek <tracek@redhat.com>
> ---
>   common.config | 1 +
>   common.rc     | 7 +++++++
>   2 files changed, 8 insertions(+)
>

Tomas,
	Looks good.
--Rich

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
