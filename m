Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 98EA07F4E
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2014 22:03:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28530AC002
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2014 20:03:15 -0700 (PDT)
Received: from mail-qc0-f170.google.com (mail-qc0-f170.google.com
	[209.85.216.170]) by cuda.sgi.com with ESMTP id
	KWuQ2Lobm4hlDZBn (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Oct 2014 20:03:10 -0700 (PDT)
Received: by mail-qc0-f170.google.com with SMTP id l6so3184299qcy.1
	for <xfs@oss.sgi.com>; Sun, 26 Oct 2014 20:03:10 -0700 (PDT)
Message-ID: <544DB5DA.4000103@gmail.com>
Date: Sun, 26 Oct 2014 23:02:50 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Re: xfsdump not work in 3.17
References: <CAGdb-8dvNOdBfZ3K_g_o22vN30yBJN+pwr-0sORC+Aubv5=9Cg@mail.gmail.com>
	<543F3C9A.4060603@sandeen.net> <5447BC4C.3050408@gmail.com>
	<544B4BB3.5030009@gmail.com>
In-Reply-To: <544B4BB3.5030009@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs <xfs@oss.sgi.com>

OK, I don't know what I did.  I reconstructed my v5/finobt / from backup
and tried to get xfsdump to fail.  It worked fine, so I crashed the PC
by letting xfstests run to xfs/014 (schedule() issue).  xfsdump still
worked.  So I ran xfs_repair and xfs_fsr on the filesystem.  xfsdump
still worked.

Thanks for reading!

Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
