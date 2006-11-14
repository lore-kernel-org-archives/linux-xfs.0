Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Nov 2006 16:52:14 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAE0q5aG019655
	for <xfs@oss.sgi.com>; Mon, 13 Nov 2006 16:52:06 -0800
Received: from smtp104.sbc.mail.mud.yahoo.com (smtp104.sbc.mail.mud.yahoo.com [68.142.198.203])
	by cuda.sgi.com (Spam Firewall) with SMTP id BF0DB51D17F
	for <xfs@oss.sgi.com>; Mon, 13 Nov 2006 16:25:38 -0800 (PST)
Date: Mon, 13 Nov 2006 16:25:36 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: XFS_IOC_RESVSP64 versus XFS_IOC_ALLOCSP64 with multiple threads
Message-ID: <20061114002536.GA7846@tuatara.stupidest.org>
References: <1163381602.11914.10.camel@localhost.localdomain> <965ECEF2-971D-46A1-B3F2-C6C1860C9ED8@sgi.com> <1163390942.14517.12.camel@localhost.localdomain> <12275452-56ED-4921-899F-EFF1C05B251A@sgi.com> <1163395250.14517.38.camel@localhost.localdomain> <950D2C3E-11AE-4805-9286-65ECD880272D@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <950D2C3E-11AE-4805-9286-65ECD880272D@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sam Vaughan <sjv@sgi.com>
Cc: Stewart Smith <stewart@mysql.com>, xfs@oss.sgi.com

On Tue, Nov 14, 2006 at 11:04:17AM +1100, Sam Vaughan wrote:

> Those extents are curiously uniform, all 32kB in size.

O_SYNC writes?
