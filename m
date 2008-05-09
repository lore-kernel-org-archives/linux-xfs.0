Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 May 2008 18:16:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m491G0p4007308
	for <xfs@oss.sgi.com>; Thu, 8 May 2008 18:16:03 -0700
Subject: TAKE 981361 - xfstests/016
Message-Id: <20080509011646.5424558C4C15@chook.melbourne.sgi.com>
Date: Fri,  9 May 2008 11:16:46 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, xfs-bugs-internal@sgi.com

Sample the log traffic to work out its data rate so that we
have a better idea of predicting when it will get to the end
of the log. This way we can handle a change in log traffic in
the future. A test to keep an eye on log traffic is more of
a performance test than should be done elsewhere.

--Tim

Date:  Fri May  9 11:15:14 AEST 2008
Workarea:  emu.melbourne.sgi.com:/home/tes/isms/xfs-cmds
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:31053a
xfstests/016 - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/016.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
xfstests/016.out - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/016.out.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- Sample the log traffic to work out its data rate so that we
	  have a better idea of predicting when it will get to the end
	  of the log. This way we can handle a change in log traffic in
	  the future.
