Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3153B7F5A
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 15:41:11 -0500 (CDT)
Message-ID: <5238BE63.8000405@sgi.com>
Date: Tue, 17 Sep 2013 15:41:07 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: check for valid input to _scratch_mkfs_sized
References: <5238ADE1.5050204@redhat.com>
In-Reply-To: <5238ADE1.5050204@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 09/17/13 14:30, Eric Sandeen wrote:
> _scratch_mkfs_sized requires an integer number of bytes
> as input; if it's given something else, catch it and _notrun.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---

Ah, the "don't do what Mark did" patch.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
