Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 491477F5F
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 20:53:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DABCAAC001
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 18:53:11 -0700 (PDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
	[209.85.212.173]) by cuda.sgi.com with ESMTP id
	Z6rrrpcFIeHQOC96 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 11 Oct 2015 18:53:10 -0700 (PDT)
Received: by wicge5 with SMTP id ge5so132187944wic.0
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 18:53:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151012002200.GB27164@dastard>
References: <1444604337-17651-1-git-send-email-andreas.gruenbacher@gmail.com>
	<1444604337-17651-39-git-send-email-andreas.gruenbacher@gmail.com>
	<20151012002200.GB27164@dastard>
Date: Mon, 12 Oct 2015 03:53:08 +0200
Message-ID: <CAHpGcMK9P=ERJZs1XnDx3QKgCsVu37tugwPcYo4Lc87QXvoppg@mail.gmail.com>
Subject: Re: [PATCH v10 38/46] richacl: Add support for unmapped identifiers
From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-cifs@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, Linux API Mailing List <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

2015-10-12 2:22 GMT+02:00 Dave Chinner <david@fromorbit.com>:
> This was used by the XFS support patch earlier in the series. Bisect
> problem here...

Yes, I'll fix that up as well.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
