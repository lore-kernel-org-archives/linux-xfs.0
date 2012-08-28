Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7SE2AtT104176 for <xfs@oss.sgi.com>; Tue, 28 Aug 2012 09:02:10 -0500
Message-ID: <503CCF9B.8080800@sgi.com>
Date: Tue, 28 Aug 2012 09:03:07 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 09/10] xfstests: disable tests that typically fail on
	large filesystems
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
	<1343291989-14987-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291989-14987-10-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/26/2012 03:39 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Test 017 typically fails due to the OOM killer kicking in and
> killing everything but xfs_db so panics the machine.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>   017 |    4 ++++
>   1 file changed, 4 insertions(+)
>

Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
