Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Sep 2006 18:11:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k841AaDW008320
	for <xfs@oss.sgi.com>; Sun, 3 Sep 2006 18:10:48 -0700
Date: Mon, 4 Sep 2006 11:09:45 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: review: minor cleanup in xfs_read locking
Message-ID: <20060904110945.A3329063@wobbly.melbourne.sgi.com>
References: <20060904101711.A3331169@wobbly.melbourne.sgi.com> <44FB75CB.8050809@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44FB75CB.8050809@sgi.com>; from lachlan@sgi.com on Mon, Sep 04, 2006 at 01:39:39AM +0100
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 04, 2006 at 01:39:39AM +0100, Lachlan McIlroy wrote:
> Looking a little closer... you could probably do away with the extra
> pair of parentheses in the call to unlikely().
> 

Done, thanks - I'll push in most of my pending stuff shortly.

cheers.

-- 
Nathan
