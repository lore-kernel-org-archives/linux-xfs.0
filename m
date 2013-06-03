Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4ECED7CBF
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 14:10:36 -0500 (CDT)
Message-ID: <51ACEA24.4080809@sgi.com>
Date: Mon, 3 Jun 2013 14:10:28 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3 v2] 285: Test offsets over 4GB
References: <1369948905-6693-1-git-send-email-jack@suse.cz>
	<1369948905-6693-3-git-send-email-jack@suse.cz>
In-Reply-To: <1369948905-6693-3-git-send-email-jack@suse.cz>
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
> Test whether SEEK_HOLE and SEEK_DATA works correctly with offsets over
> 4GB, 8TB, and 16TB.
>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, this patch has been committed.

commit e2549c60dd44b4d00a82bbc4acc91e094544839f
Author: Jan Kara <jack@suse.cz>
Date:   Mon Jun 3 13:53:49 2013 -0500

     xfstests 285: Test offsets over 4GB

--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
