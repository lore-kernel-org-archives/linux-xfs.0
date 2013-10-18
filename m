Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A8C67F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:24:31 -0500 (CDT)
Message-ID: <52616EC6.7030400@sgi.com>
Date: Fri, 18 Oct 2013 12:24:22 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH RESEND 4/7] xfsprogs: xfsio: add support
	FALLOC_FL_COLLAPSE_RANGE for fallocate
References: <1381090418-2829-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1381090418-2829-1-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>, viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, tytso@mit.edu, adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org, hch@infradead.org, david@fromorbit.com
Cc: Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

This has been committed.

Thanks
--Rich

commit e64190f8440286a815060524777b435e06a7b364
Author: Namjae Jeon <namjae.jeon@samsung.com>
Date:   Sun Oct 6 20:13:38 2013 +0000

     [RESEND, 4/7] xfsprogs: xfsio: add support FALLOC_FL_COLLAPSE_RANGE 
for fallocate

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
