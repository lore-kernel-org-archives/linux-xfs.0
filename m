Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 883BC7F37
	for <xfs@oss.sgi.com>; Fri, 31 May 2013 07:29:25 -0500 (CDT)
Message-ID: <51A897DC.1030801@sgi.com>
Date: Fri, 31 May 2013 07:30:20 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3 v2] 285: Fix indentation of do_pwrite
References: <1369948905-6693-1-git-send-email-jack@suse.cz>
	<1369948905-6693-2-git-send-email-jack@suse.cz>
In-Reply-To: <1369948905-6693-2-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On 05/30/2013 04:21 PM, Jan Kara wrote:
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   src/seek_sanity_test.c | 26 +++++++++++++-------------
>   1 file changed, 13 insertions(+), 13 deletions(-)
>
Thanks for the patch, it has been committed:

commit 1515c26fd44ee2f84ce43ebcd9168130801dd9a0
Author: Jan Kara <jack@suse.cz>
Date:   Fri May 31 07:19:47 2013 -0500

     xfstests 285: Fix indentation of do_pwrite

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
