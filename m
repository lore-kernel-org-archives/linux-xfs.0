Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 327627CA2
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 10:28:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EBB09304032
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 08:28:47 -0800 (PST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com
	[74.125.82.54]) by cuda.sgi.com with ESMTP id nVUrKWtEupo2L0oI
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 07 Feb 2016 08:28:45 -0800 (PST)
Received: by mail-wm0-f54.google.com with SMTP id r129so85202527wmr.0
	for <xfs@oss.sgi.com>; Sun, 07 Feb 2016 08:28:45 -0800 (PST)
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: RichACLs man-pages review
Message-ID: <56B770B6.7040803@gmail.com>
Date: Sun, 7 Feb 2016 17:28:38 +0100
MIME-Version: 1.0
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Andreas Dilger <adilger@dilger.ca>, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, lkml <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

Hello Andreas

I've taken a look at the current drafts of the setrichacl(1), 
getrichacl(1), and richacl(7) man pages, and will send comments
as separate following mails.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
