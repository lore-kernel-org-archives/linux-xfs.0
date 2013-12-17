Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1E9F27F3F
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 11:05:17 -0600 (CST)
Message-ID: <52B08446.3080102@sgi.com>
Date: Tue, 17 Dec 2013 11:05:10 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v4 4/10] xfsprog: xfsio: Add support
	FALLOC_FL_COLLAPSE_RANGE for fallocate
References: <1386511890-3794-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1386511890-3794-1-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>, viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz
Cc: Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

This patch stands alone and has been committed.

Thanks
--Rich

commit ca692f162d36c871c9c1b6169136b2c70503f2d8
Author: Namjae Jeon <namjae.jeon@samsung.com>
Date:   Sun Dec 8 14:11:30 2013 +0000

     xfsprog: xfsio: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
