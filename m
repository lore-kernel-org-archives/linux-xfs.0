Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Sep 2007 18:05:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8D15S4p023475
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 18:05:29 -0700
Message-ID: <46E88CD0.2050309@sgi.com>
Date: Thu, 13 Sep 2007 11:05:20 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: state of the cvs tree
References: <20070912121938.GA16870@lst.de> <46E870AB.30906@sgi.com>
In-Reply-To: <46E870AB.30906@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com, Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Mark Goodwin wrote:
> 
> 
> Christoph Hellwig wrote:
>> looks like the cvs tree is broken currently - fs/xfs/ is merged up to
>> 2.6.23-rc, but everything else is still at 2.6.22-rc state leading to
>> various compile failures.
> 
> I think Tim is in the middle of the .23 update and still has some more
> to push in. Tim?
> 
No I don't :-) I did have some followup dmapi fixes but they got added
yesterday.
The sgi ptools 2.6.x-xfs tree seems just fine for me, is building and
does have the 23-rc4 (only rc4 b/c only had kdb for that at the time) AFAICS.
I guess there must be something wrong then with the cvs sync.
It must be sync'ing the embedded xfs-linux tree okay but not
the 2.6.x-xfs kernel tree.
I'll see what I can find out.

BTW, sorry for not mentioning the update on oss. I will do that
next time.

--Tim
