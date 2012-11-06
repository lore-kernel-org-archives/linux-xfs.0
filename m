Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6Gkoqf075518 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 10:46:50 -0600
Message-ID: <50993F6D.9000005@sgi.com>
Date: Tue, 06 Nov 2012 10:48:45 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v6 08/10] xfs: support multiple inode id filtering in
	eofblocks scan
References: <1352213447-59791-1-git-send-email-bfoster@redhat.com>
	<1352213447-59791-9-git-send-email-bfoster@redhat.com>
In-Reply-To: <1352213447-59791-9-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 11/06/12 08:50, Brian Foster wrote:
> Enhance the eofblocks scan code to filter based on multiply specified
> inode id values. When multiple inode id values are specified, only
> inodes that match all id values are selected.
>
> Signed-off-by: Brian Foster<bfoster@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
