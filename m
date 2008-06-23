Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jun 2008 21:42:27 -0700 (PDT)
Received: from itchy (itchy.melbourne.sgi.com [134.14.55.96])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5N4gJ8C017139
	for <xfs@oss.sgi.com>; Sun, 22 Jun 2008 21:42:20 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: [RFC] Create with EA initial work
Date: Mon, 23 Jun 2008 14:42:26 +1000
Message-Id: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Here's a dump of current work for Create+EA, this is buggy, it's
dropped out as I'm a bit busy and some people out there might be
interested in having a look.

These set of patches will move things around to make it possible to
pass a transaction down to the EA subsystem on create, but it seemed
to need more love.

Comments are welcome.
