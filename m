Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Jul 2006 09:14:04 -0700 (PDT)
Received: from smtp106.sbc.mail.mud.yahoo.com (smtp106.sbc.mail.mud.yahoo.com [68.142.198.205])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6LGDoDW027855
	for <xfs@oss.sgi.com>; Fri, 21 Jul 2006 09:13:50 -0700
Date: Fri, 21 Jul 2006 09:13:26 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Page allocation failure writing to an XFS volume via NFS on CentOS 4.3
Message-ID: <20060721161326.GE12347@tuatara.stupidest.org>
References: <68559cef0607210519q9f382c6n7104bef9cf9716f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68559cef0607210519q9f382c6n7104bef9cf9716f3@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Luca Maranzano <liuk001@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 21, 2006 at 02:19:34PM +0200, Luca Maranzano wrote:

> kswapd0: page allocation failure. order:0, mode:0xd0

you're out of memory, see what's being so piggy
