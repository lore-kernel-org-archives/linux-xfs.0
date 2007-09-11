Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Sep 2007 18:31:24 -0700 (PDT)
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.190])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8C1VI4p029775
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2007 18:31:19 -0700
Received: by rv-out-0910.google.com with SMTP id k20so44028rvb
        for <xfs@oss.sgi.com>; Tue, 11 Sep 2007 18:31:20 -0700 (PDT)
Message-ID: <654e62180709111643k4700c2bdibec2a16eb5446e76@mail.gmail.com>
Date: Tue, 11 Sep 2007 16:43:20 -0700
From: "Jordan Mendler" <jmendler@ucla.edu>
Subject: compression
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,

I searched the mailing list archive and could not find an answer. We are
currently using XFS on Linux for a 17TB Volume used for backups. We are
running out of space, so rather than order another array, I would like to
try to implement filesystem-level compression. Does XFS support any type of
compression? If not, are there any other ways to optimize for more space
storage? We are doing extensive rsyncs as our method of backups, so gzipping
on top of the filesystem is not really an option.

Thanks so much,
Jordan


[[HTML alternate version deleted]]
