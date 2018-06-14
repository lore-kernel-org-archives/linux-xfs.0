Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45686 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935616AbeFNCLd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jun 2018 22:11:33 -0400
Subject: Re: Strange XFS problem
References: <e462d333d2089a7c3c59e7584fa83f720365fa46.camel@quantentunnel.de>
 <0ae6d0d5984dcd9c703720bdf41b6da1333267b0.camel@quantentunnel.de>
 <20180605082917.azuql22j5wnb7wof@odin.usersys.redhat.com>
 <CAAxjCEwS5mcEMPCqJmUiUParsaG7Fxzf0c0GxkJURv85fYuJyw@mail.gmail.com>
 <a2dbfee3-f5dc-b4c3-24c9-153fe3304d10@sandeen.net>
 <CAAxjCExfy6ysDCOPX7G9HNJvqojbgQHu54QwMrcGROhu1JnMLg@mail.gmail.com>
 <4cd7af90-6c71-fd1b-edcc-f026331b951c@sandeen.net>
 <20180613220211.GF10363@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7a83fbd5-dabc-7661-b3e8-6472e0839863@sandeen.net>
Date: Wed, 13 Jun 2018 21:11:31 -0500
MIME-Version: 1.0
In-Reply-To: <20180613220211.GF10363@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org



On 6/13/18 5:02 PM, Dave Chinner wrote:
> On Tue, Jun 12, 2018 at 01:56:06PM -0500, Eric Sandeen wrote:
>>
>>
>> On 6/12/18 1:53 PM, Stefan Ring wrote:
>>> On Tue, Jun 5, 2018 at 4:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>>> In all seriousness, if you would like to update the translations that would
>>>> be great.  The Polish translation is the only one that receives regular
>>>> updates today.
>>>
>>> I've looked into it, but this seems to me like a gargantuan task
>>> because there is so much internal inconsistency that I wouldn't even
>>> know where to start. "Extent" for example: sometimes this is
>>> translated as "Erweiterung" (nonsense, that's extension). Sometimes
>>> it's left verbatim. This is what I'd be leaning towards as well. Other
>>> times, it got translated as "Ausmaß", which in another context is in
>>> fact a translation for "extent" (as in: the extent of a catastrophy),
>>> but makes no sense here. Also "Bereich" and "Umfang" are used
>>> sometimes, of which only the former makes a slight bit of sense. That
>>> in addition to my general under-appreciation of low-level technical
>>> translation. They are usually much less comprehensible and the
>>> gibberish needs to be translated back anyway in order to any sense of,
>>> apart from the fact that the original text is searchable, in stark
>>> contrast to the translation.
>>
>> Thanks for looking.
>>
>> Is the German translation bad/embarrassing enough that it should just
>> be removed?  Does it do more harm than good at this point?
> 
> Don't distro's have internationalisation teams precisely for doing
> translations of packages? If so, shouldn't we be asking for those
> teams to do translation work?

Sorta?

https://fedoraproject.org/wiki/L10N/Translate_on_Zanata

https://fedora.zanata.org

We could try to pursue that, but it currently has very few packages
on its "priority" list (anaconda, etc)

-Eric
