Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 45B777F59
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 18:56:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3465130405F
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 16:56:04 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	J9ENX9tKSaPGCwRJ for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 16:56:02 -0800 (PST)
Date: Tue, 17 Feb 2015 11:56:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND 4/12] xfsprog: xfsio: update xfs_io manpage for
	FALLOC_FL_INSERT_RANGE
Message-ID: <20150217005600.GF4251@dastard>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
	<1424101680-3301-5-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424101680-3301-5-git-send-email-linkinjeon@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-man@vger.kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-api@vger.kernel.org, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@gmail.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue, Feb 17, 2015 at 12:47:51AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Update xfs_io manpage for FALLOC_FL_INSERT_RANGE.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Looks good. That'll fix up the complaining fstest ;)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-Dave
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
