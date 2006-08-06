Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Aug 2006 13:47:05 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.183])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k76KkoDW031390
	for <xfs@oss.sgi.com>; Sun, 6 Aug 2006 13:46:51 -0700
Received: by py-out-1112.google.com with SMTP id c39so384270pyd
        for <xfs@oss.sgi.com>; Sun, 06 Aug 2006 13:46:24 -0700 (PDT)
Message-ID: <83d59530608061232r21feab01j456c7d1fec742958@mail.gmail.com>
Date: Sun, 6 Aug 2006 20:32:49 +0100
From: "Jeff Briggs" <ephemeral.elusive@gmail.com>
Subject: XFS null files
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello.

I've just lost data to XFS, with the files full of nulls. I've found
posts dating back over two years about such data losses. I'm using
linux 2.6.17 with xfsprogs 2.8.10.

emacs claims to fsync on write, yet still I lost data, the faq
suggests I should not have if this is so?

Is this likely to be fixed soon, or should I switch file system?

Many thanks.
