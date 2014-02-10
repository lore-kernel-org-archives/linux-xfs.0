Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 645C67F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 16:13:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 374FC8F8035
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 14:13:22 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7wBRki9Eecvqn5TU for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 14:13:20 -0800 (PST)
Date: Tue, 11 Feb 2014 09:12:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND 1/10] fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE)
	for fallocate
Message-ID: <20140210221259.GW13647@dastard>
References: <1391319821-3135-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1391319821-3135-1-git-send-email-linkinjeon@gmail.com>
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
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, adilger.kernel@dilger.ca, mtk.manpages@gmail.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk

On Sun, Feb 02, 2014 at 02:43:41PM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate.
> updated detailed semantics in comments.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

Looks OK to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
