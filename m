Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A4177F82
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 15:42:45 -0500 (CDT)
Message-ID: <520A9A37.6070501@sgi.com>
Date: Tue, 13 Aug 2013 15:42:31 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfs: Add support for the Q_XGETQSTATV
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
	<1375828029-26360-3-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1375828029-26360-3-git-send-email-sekharan@us.ibm.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Abhijith Das <adas@redhat.com>, Jan Kara <jack@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>, xfs@oss.sgi.com

Looks good:

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

On 08/06/2013 05:27 PM, Chandra Seetharaman wrote:
> For XFS, add support for Q_XGETQSTATV quotactl command.
>
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>   fs/xfs/xfs_qm.h          |    2 +
>   fs/xfs/xfs_qm_syscalls.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++
>   fs/xfs/xfs_quotaops.c    |   13 +++++++
>   3 files changed, 97 insertions(+), 0 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
