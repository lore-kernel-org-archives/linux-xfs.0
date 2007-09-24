Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 09:14:38 -0700 (PDT)
Received: from smtp120.sbc.mail.sp1.yahoo.com (smtp120.sbc.mail.sp1.yahoo.com [69.147.64.93])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8OGEVQ3004528
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 09:14:34 -0700
Date: Mon, 24 Sep 2007 09:14:33 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Review: fix mount flags as printed by xfsidbg
Message-ID: <20070924161433.GA4098@puku.stupidest.org>
References: <46F78159.5080907@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F78159.5080907@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Donald Douwsma <donaldd@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 24, 2007 at 07:20:25PM +1000, Donald Douwsma wrote:

> -		"32BITINOOPT",	/* 0x8000 */
> +		"SMALL_INUMS",	/* 0x8000 */

why rename that?
