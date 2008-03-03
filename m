Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Mar 2008 05:15:47 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m23DFd4D026989
	for <xfs@oss.sgi.com>; Mon, 3 Mar 2008 05:15:40 -0800
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DB06639D82
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2008 05:16:07 -0800 (PST)
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.169]) by cuda.sgi.com with ESMTP id pihDvcLYTeQOkc1M for <xfs@oss.sgi.com>; Mon, 03 Mar 2008 05:16:07 -0800 (PST)
Received: by wf-out-1314.google.com with SMTP id 29so62wff.32
        for <xfs@oss.sgi.com>; Mon, 03 Mar 2008 05:16:07 -0800 (PST)
Message-ID: <e1d7613e0803030516g51b0bdafo2bbdb39649aaa1d3@mail.gmail.com>
Date: Mon, 3 Mar 2008 21:16:07 +0800
From: cgxu <cgxu.gg@gmail.com>
Subject: Will this functon be used?
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, xfscn@googlegroups.com

Hi

I found a function which never been used in the shortform directory format.
It named xfs_dir2_sf_addname_hard().
The purpose of this function is to insert a new entry to the
existent entry's hole.
While you remove a entry in shortform format, the residual entrys will move
forward,
so it will never make a hole in the shortform format entrys.


Best Regards
Kevin Xu


[[HTML alternate version deleted]]
