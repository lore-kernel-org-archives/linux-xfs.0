Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Apr 2007 00:37:27 -0700 (PDT)
Received: from mail3b1.westend.com (mail3b.westend.com [212.117.79.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l357bOfB030945
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 00:37:25 -0700
Date: Thu, 5 Apr 2007 09:37:21 +0200
From: Thomas Kaehn <tk@westend.com>
Subject: Re: Strange delete performance using XFS
Message-ID: <20070405073721.GC2759@mail3b.westend.com>
References: <20070404130535.GE18320@mail3b.westend.com> <Pine.LNX.4.64.0704040928110.7309@p34.internal.lan> <20070404134724.GF18320@mail3b.westend.com> <Pine.LNX.4.64.0704041436140.16731@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0704041436140.16731@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Hi Justin,

On Wed, Apr 04, 2007 at 02:36:37PM -0400, Justin Piszcz wrote:
> For the ext3, try time bash -c 'rm -rf test; sync'

# time bash -c 'rm -rf y; sync'

real    0m1.592s
user    0m0.032s
sys     0m1.408s


Ciao,
Thomas
-- 
Thomas Kähn                   WESTEND GmbH  |  Internet-Business-Provider
Technik                       CISCO Systems Partner - Authorized Reseller
                              Im Süsterfeld 6          Tel 0241/701333-18
tk@westend.com                D-52072 Aachen              Fax 0241/911879
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Die Gesellschaft ist eingetragen im Handelsregister Aachen unter HRB 7608
Geschäftsführer:           Thomas Neugebauer, Thomas Heller, Michael Kolb
