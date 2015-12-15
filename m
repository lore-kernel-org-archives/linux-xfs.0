Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3F80F7F37
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 05:12:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 134FC8F8040
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 03:12:18 -0800 (PST)
Received: from mail-lb0-f180.google.com (mail-lb0-f180.google.com
	[209.85.217.180]) by cuda.sgi.com with ESMTP id
	yaxz2k2CeKDRd1O9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Dec 2015 03:12:17 -0800 (PST)
Received: by mail-lb0-f180.google.com with SMTP id cs9so3354080lbb.1
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 03:12:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1449090088-9281-1-git-send-email-agruenba@redhat.com>
References: <1449090088-9281-1-git-send-email-agruenba@redhat.com>
Date: Tue, 15 Dec 2015 12:12:15 +0100
Message-ID: <CAHc6FU6AdiKzxNDZu3xpEUMa0TTKHkDSQtn7SopCHm1zZF3cAQ@mail.gmail.com>
Subject: Re: [PATCH v16 00/22] Richacls (Core and Ext4)
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-cifs@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>

An updated version of the richacl patches rebased on top of the recent
xattr cleanups (Al's work.xattr branch) is available here:

   git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.git \
         richacl-2015-12-15

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
